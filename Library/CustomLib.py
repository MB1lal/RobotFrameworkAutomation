import random
import string
import json

__version__ = '1.0.0'

from robot.api.deco import keyword


class CustomLib:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    @keyword('Generate random name')
    def get_random_name(self, email_length):
        letters = string.ascii_lowercase[:12]
        return ''.join(random.choice(letters) for i in range(email_length))

    # def generate_random_emails(self, length):
    #     domains = ["hotmail.com", "gmail.com", "aol.com",
    #                "mail.com", "mail.kz", "yahoo.com"]
    #
    #     return [self.get_random_name(length)
    #             + '@'
    #             + random.choice(domains)]
