"""Custom Robot Framework keywords for generating test data."""

import random
import string

__version__ = '2.0.0'

from robot.api.deco import keyword


class CustomLib:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'TEST'

    @keyword('Generate Random Name')
    def get_random_name(self, length=10):
        """Return a random lowercase name of ``length`` characters.

        Example: ``${name}=    Generate random name    ${12}``
        """
        length = int(length)
        if length < 1:
            raise ValueError('length must be a positive integer')
        letters = string.ascii_lowercase
        return ''.join(random.choice(letters) for _ in range(length))

    @keyword('Generate Random Id')
    def generate_random_id(self, low=100000, high=999999):
        """Return a random int id between ``low`` and ``high`` (inclusive).

        Unique-ish ids keep parallel runs and reruns from colliding
        on the shared demo API.
        """
        return random.randint(int(low), int(high))
