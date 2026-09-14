"""Petstore payload builder.

Pure-python keyword library (no network): keeps payload shape in one
place so API suites don't duplicate dictionaries.
"""

__version__ = '2.0.0'

from robot.api.deco import keyword


class PetConnector:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'TEST'

    @keyword('Build Pet Payload')
    def build_pet_payload(self, pet_id, name='TestingDragon', category_id=569,
                          category_name='TestDragon', status='available'):
        """Build a petstore ``POST /pet`` JSON payload as a dict.

        Example: ``${payload}=    Build Pet Payload    pet_id=${id}    status=sold``
        """
        category = {'id': int(category_id), 'name': category_name}
        return {
            'id': int(pet_id),
            'category': category,
            'name': name,
            'photoUrls': ['photoURL'],
            'tags': [category],
            'status': status,
        }
