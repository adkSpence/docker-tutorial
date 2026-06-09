from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    return {"message": "In the galatic world beyond!"}


@app.get("/health")
def health():
    return {"status": "ok"}
