from fastapi import FastAPI

from app.api.v1.api import router as api_router

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}

app.include_router(api_router, prefix="/api/v1")
