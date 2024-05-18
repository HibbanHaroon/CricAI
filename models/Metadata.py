class Metadata:
    def __init__(self, ideal_angles, shotType):
        self.ideal_angles = ideal_angles
        self.shotType = shotType

    @staticmethod
    def from_dict(source):
        pass

    def to_dict(self):
        return {
            "ideal_angles": self.ideal_angles,
            "shotType": self.shotType
        }

    def __repr__(self):
        return f"Metadata(\
                ideal_angles={self.ideal_angles}, \
                shotType={self.shotType},\
            )"