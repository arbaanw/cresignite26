# CribeIt Analyze API

FastAPI service that accepts a product photo + language and returns a **hardcoded
demo listing** plus a static edited saree image URL. No Gemini/OpenAI calls.

## Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Optional in `.env`:

```
PUBLIC_BASE_URL=https://your-deployed-host
```

Used when building `edited_image_url` behind a reverse proxy.

## Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

- Health: `GET /health`
- Demo image: `GET /demo/edited_saree.png`
- Analyze: `POST /analyze`

## Endpoint

`POST /analyze` multipart form:

| field | type | notes |
|-------|------|--------|
| `image` | file | required; validated then ignored for AI |
| `language` | string | `en`, `hi`, or `ta` |

Response:

```json
{
  "name": "Handwoven Silk Saree",
  "description": "A traditional handwoven silk saree crafted by skilled Indian artisans.",
  "suggested_price": 4500,
  "edited_image_url": "http://127.0.0.1:8000/demo/edited_saree.png"
}
```

## Curl smoke test

```bash
curl -s -X POST http://127.0.0.1:8000/analyze \
  -F "language=en" \
  -F "image=@/path/to/photo.jpg"
```
