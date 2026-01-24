from wire import wire
class module():
    def __init__(self, inputs: list[wire], outputs: list[wire], delay: int = 0) -> module:
        self.inputs = inputs
        self.outputs = outputs
        self.delay = delay
    def __enter__(self):
        return self
    def __exit__(self):
        pass

    