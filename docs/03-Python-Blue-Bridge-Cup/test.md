# Python agent for feeding yljcat and txrcat

A tiny playful note to verify Python code highlighting in MkDocs Material.

```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Cat:
    name: str
    snack: str


def feed(cat: Cat) -> str:
    ts = datetime.now().strftime("%H:%M:%S")
    return f"[{ts}] Agent fed {cat.name} with {cat.snack}."


cats = [Cat("yljcat", "salmon"), Cat("txrcat", "chicken")]
for c in cats:
    print(feed(c))
```

你好哦
