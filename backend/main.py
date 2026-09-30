"""
CribeIt analyze API — accepts a product photo + language, returns
name, short description, and a suggested INR price via Google GenAI (Gemini).
"""

from __future__ import annotations

import json
import os
import re
from typing import Literal

from dotenv import load_dotenv
from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from google import genai
from google.genai import types
from pydantic import BaseModel, Field

load_dotenv()

Language = Literal["en", "hi", "ta"]

LANGUAGE_LABELS = {
    "en": "English",
    "hi": "Hindi",
    "ta": "Tamil",
}

app = FastAPI(title="CribeIt Analyze API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class AnalyzeResponse(BaseModel):
    name: str
    description: str
    suggested_price: float = Field(..., ge=0)


def _api_key() -> str:
    return (
        os.getenv("GEMINI_API_KEY", "").strip()
        or os.getenv("GOOGLE_API_KEY", "").strip()
    )


def _use_mock() -> bool:
    if os.getenv("MOCK_AI", "").lower() in {"1", "true", "yes"}:
        return True
    return not bool(_api_key())


def _mock_analyze(language: Language) -> AnalyzeResponse:
    """Offline fallback so the Flutter ↔ FastAPI pipe can be tested without a key."""
    copy = {
        "en": (
            "Handwoven Cotton Saree",
            "Traditional handwoven cotton saree crafted by skilled artisans. "
            "Lightweight, breathable, and inspired by timeless regional patterns.",
        ),
        "hi": (
            "हस्तनिर्मित सूती साड़ी",
            "कुशल कारीगरों द्वारा हाथ से बुनी गई पारंपरिक सूती साड़ी। "
            "हल्की, सांस लेने योग्य और पारंपरिक डिज़ाइनों से प्रेरित।",
        ),
        "ta": (
            "கைத்தறி பருத்தி புடவை",
            "திறமையான கைவினைஞர்களால் நெய்யப்பட்ட பாரம்பரிய பருத்தி புடவை. "
            "இலகுவானது, காற்றோட்டமானது, பாரம்பரிய வடிவமைப்புகளால் ஈர்க்கப்பட்டது.",
        ),
    }
    name, description = copy[language]
    return AnalyzeResponse(name=name, description=description, suggested_price=2850.0)


def _extract_json(text: str) -> dict:
    text = text.strip()
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        match = re.search(r"\{.*\}", text, re.DOTALL)
        if not match:
            raise ValueError("Model did not return JSON")
        return json.loads(match.group(0))


def _vision_analyze(image_bytes: bytes, content_type: str, language: Language) -> AnalyzeResponse:
    client = genai.Client(api_key=_api_key())
    model = os.getenv("GEMINI_MODEL", "gemini-2.0-flash")
    lang_label = LANGUAGE_LABELS[language]
    mime = content_type or "image/jpeg"

    prompt = f"""You are helping Indian artisans list handmade crafts on a marketplace.

Look at the product photo and return ONLY valid JSON with these keys:
- "name": short product name (max ~6 words)
- "description": 1-2 sentences marketplace description written in {lang_label}
- "suggested_price": integer INR retail price suggestion (no currency symbol)

Rules:
- Focus on handmade / craft goods from India when plausible.
- If the object is unclear, still give a best-effort craft listing.
- suggested_price must be a number, not a string.
- Do not wrap the JSON in markdown fences."""

    response = client.models.generate_content(
        model=model,
        contents=[
            types.Part.from_bytes(data=image_bytes, mime_type=mime),
            prompt,
        ],
        config=types.GenerateContentConfig(
            temperature=0.4,
            response_mime_type="application/json",
        ),
    )

    raw = response.text or "{}"
    data = _extract_json(raw)
    try:
        return AnalyzeResponse(
            name=str(data["name"]).strip(),
            description=str(data["description"]).strip(),
            suggested_price=float(data["suggested_price"]),
        )
    except (KeyError, TypeError, ValueError) as exc:
        raise HTTPException(status_code=502, detail=f"Invalid model response: {exc}") from exc


@app.get("/health")
def health() -> dict:
    return {"ok": True, "mock_ai": _use_mock(), "provider": "google-genai"}


@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze(
    image: UploadFile = File(...),
    language: Language = Form("en"),
) -> AnalyzeResponse:
    if language not in LANGUAGE_LABELS:
        raise HTTPException(status_code=400, detail="language must be en, hi, or ta")

    image_bytes = await image.read()
    if not image_bytes:
        raise HTTPException(status_code=400, detail="Empty image upload")
    if len(image_bytes) > 12 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="Image too large (max 12MB)")

    if _use_mock():
        return _mock_analyze(language)

    try:
        return _vision_analyze(
            image_bytes=image_bytes,
            content_type=image.content_type or "image/jpeg",
            language=language,
        )
    except HTTPException:
        raise
    except Exception as exc:  # noqa: BLE001 — surface upstream errors cleanly
        raise HTTPException(status_code=502, detail=f"AI analyze failed: {exc}") from exc
