from pydantic import BaseModel

class Colour(BaseModel):
    colour : list[float] = []
    spread : float = 0
    precentage : float = 0


class DominantResponse(BaseModel):
    dominant : list[Colour] = []

