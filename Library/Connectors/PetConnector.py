"""Petstore payload builder and response validator.

Pure-python keyword library: payload shape and schema checks live in one
place so API suites don't duplicate dictionaries.
"""

import json
from pathlib import Path

__version__ = '2.1.0'

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

    @keyword('Validate Pet Schema')
    def validate_pet_schema(self, data, schema_path):
        """Validate a response body ``data`` against the JSON schema file.

        Raises an AssertionError listing every violation.
        """
        import jsonschema

        schema = json.loads(Path(schema_path).read_text(encoding='utf-8'))
        validator = jsonschema.Draft202012Validator(schema)
        errors = sorted(validator.iter_errors(data), key=lambda e: list(e.path))
        if errors:
            details = '\n'.join(
                f"- {'/'.join(str(p) for p in e.path) or '<root>'}: {e.message}"
                for e in errors
            )
            raise AssertionError(f'Response does not match {schema_path}:\n{details}')
        return True
