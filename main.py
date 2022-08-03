from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/users")
async def get_users():
    return {"message": "Get users!"}