"""
CribeIt analyze API — accepts a product photo + language, returns
a hardcoded demo listing plus a static edited saree image URL.
"""

from __future__ import annotations

from pathlib import Path
from typing import Literal
import os

from dotenv import load_dotenv
from fastapi import FastAPI, File, Form, HTTPException, Request, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

load_dotenv()

Language = Literal["en", "hi", "ta"]

LANGUAGE_LABELS = {
    "en": "English",
    "hi": "Hindi",
    "ta": "Tamil",
}

DEMO_DIR = Path(__file__).resolve().parent / "demo"
EDITED_SAREE_FILENAME = "edited_saree.png"

app = FastAPI(title="CribeIt Analyze API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/demo", StaticFiles(directory=str(DEMO_DIR)), name="demo")


class AnalyzeResponse(BaseModel):
    name: str
    description: str
    suggested_price: float = Field(..., ge=0)
    edited_image_url: str


def _public_base(request: Request) -> str:
    configured = os.getenv("PUBLIC_BASE_URL", "").strip().rstrip("/")
    if configured:
        return configured
    return str(request.base_url).rstrip("/")


def _demo_response(request: Request) -> AnalyzeResponse:
    base = _public_base(request)
    return AnalyzeResponse(
        name="Handwoven Silk Saree",
        description=(
            "A traditional handwoven silk saree crafted by skilled Indian artisans."
        ),
        suggested_price=4500,
        edited_image_url=f"{base}/demo/{EDITED_SAREE_FILENAME}",
    )


@app.get("/health")
def health() -> dict:
    return {
        "ok": True,
        "mock_ai": True,
        "provider": "hardcoded-demo",
        "edited_image": f"/demo/{EDITED_SAREE_FILENAME}",
    }


@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze(
    request: Request,
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

    # Demo: validate upload only — no Gemini/OpenAI processing.
    _ = language
    return _demo_response(request)
