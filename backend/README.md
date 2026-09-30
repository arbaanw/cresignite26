# CribeIt Analyze API

FastAPI service that accepts a product photo + language and returns:

- `name`
- `description` (in the chosen language)
- `suggested_price` (INR)

## Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

### Real AI (OpenAI vision)

Set in `.env`:

```
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini
MOCK_AI=false
```

### Mock AI (no key needed)

Leave `OPENAI_API_KEY` empty, or set `MOCK_AI=true`. The endpoint still works and returns a seeded saree listing in `en` / `hi` / `ta`.

## Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Health check: [http://127.0.0.1:8000/health](http://127.0.0.1:8000/health)

## Endpoint

`POST /analyze` multipart form:

| field | type | notes |
|-------|------|--------|
| `image` | file | jpg/png/webp |
| `language` | string | `en`, `hi`, or `ta` |

Response:

```json
{
  "name": "Handwoven Cotton Saree",
  "description": "...",
  "suggested_price": 2850
}
```

## Curl smoke test

```bash
curl -s -X POST http://127.0.0.1:8000/analyze \
  -F "language=en" \
  -F "image=@/path/to/photo.jpg"
```
