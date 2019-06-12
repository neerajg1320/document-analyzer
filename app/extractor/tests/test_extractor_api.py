from django.contrib.auth import get_user_model
from django.urls import reverse
from django.test import TestCase

from rest_framework import status
from rest_framework.test import APIClient

from core.models import Extractor

from extractor.serializers import ExtractorListSerializer, \
    ExtractorDetailSerializer

EXTRACTOR_URL = reverse('extractor:extractor-list')


# Used for extractor testing
def basic_user(email="basic@abc.com", password="Basic123"):
    user = get_user_model().objects.create_user(email, password)
    user.is_staff = False
    return user


def staff_user(email="staff@abc.com", password="Staff123"):
    user = get_user_model().objects.create_user(email, password)
    user.is_staff = True
    return user


sample_regex_str = r"""(?#
)(?P<trade_date>\d{2}\/\d{2}\/\d{2})(?:\s){1,2}(?#
)(?P<setl_date>\d{2}\/\d{2}\/\d{2})(?:\s){1,2}(?#
)(?P<mkt>[\w]+)(?:\s){1,2}(?#
)(?P<cap>[\w]+)(?:\s){1,2}(?#
)(?:(?P<symbol>[\w]+)(?:\s){1,2}(?#
))?(?# symbol/cusip is only for EQ
)(?P<trade_type>[\w]+)(?:\s){1,2}(?#
)(?P<trade_qty>[,.\-\d]+)(?:\s){1,2}(?#
)(?P<trade_rate>[\$,.\-\d]+)(?:\s){1,2}(?#
)(?P<acct_type>[\w]+)(?:\s){1,2}(?#
)(?P<marker_principal>PRINCIPAL)(?:\s){1,2}(?#
)(?P<principal>[\$,.\-\d]+)(?:\s){1,2}(?#
)(?:(?P<option>(?#
    )(?P<opt_type>CALL|PUT) (?#
    )(?P<opt_name>[\w]+) (?#
    )(?P<expiry_date>\d{2}\/\d{2}\/\d{2}) (?#
    )(?P<strike_price>[\$,.\-\d]+))(?#
)(?:\s){1,2})?(?#
)(?P<scrip_commission_fee>(?:.|\s)*?)(?:\s){1,2}(?#
)(?P<marker_net_amount>NET AMOUNT)(?:\s){1,2}(?#
)(?P<net_amount>[\$,.\-\d]+)(?:\s){1,2}(?#
)(?#
)"""

reference_str = "https://regex101.com/r/IOOXNI/1"


def sample_extractor(user, **params):
    """ Create and return a sample extractor """
    defaults = {
        'title': 'Sample Extractor',
        'institute_name': 'Etrade',
        'document_type': 'ContractNote',
        'regex_parser': sample_regex_str,
        'reference': reference_str,
    }
    defaults.update(params)

    return Extractor.objects.create(user=user, **defaults)


# List: /api/docminer/extractors/
# Detail: /api/docminer/extractors/<id>/
def extractor_detail_url(extractor_id):
    """ Return recipe details URL """
    return reverse('extractor:extractor-detail', args=[extractor_id])


class PublicExtractorsApiTests(TestCase):
    """ Test the publicly available Extractor API """

    def setUp(self):
        self.client = APIClient()

    def test_auth_required(self):
        """ Test that login is required for retirieving tags """
        res = self.client.get(EXTRACTOR_URL)

        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)


class PrivateExtractorsApiTests(TestCase):
    """ Test the authenticated user Extractor API """

    def setUp(self):
        self.user = get_user_model().objects.create_user(
            'test@abc.com',
            'Test123',
        )
        self.client = APIClient()
        self.client.force_authenticate(self.user)

    def test_retrieve_extractors(self):
        """ Test retrieving a list of extractors """
        sample_extractor(user=self.user)
        sample_extractor(user=self.user)

        res = self.client.get(EXTRACTOR_URL)

        extractors = Extractor.objects.all().order_by('-id')
        serializer = ExtractorListSerializer(extractors, many=True)

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data, serializer.data)

    def test_extractors_limited_to_authenticated_user(self):
        """" Test that extractors for authenticated user only are retrieved """
        user2 = get_user_model().objects.create_user(
            'second@abc.com',
            'Second123'
        )
        sample_extractor(user=user2)
        sample_extractor(user=user2)
        sample_extractor(user=self.user)
        sample_extractor(user=self.user)

        res = self.client.get(EXTRACTOR_URL)

        extractors = Extractor.objects.filter(user=self.user)
        serializer = ExtractorListSerializer(extractors, many=True)

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(len(res.data), 2)
        self.assertEqual(res.data, serializer.data)

    def test_view_extractor_detail(self):
        """ Test viewing a extractor detail """
        extractor = sample_extractor(user=self.user)

        url = extractor_detail_url(extractor.id)
        res = self.client.get(url)

        serializer = ExtractorDetailSerializer(extractor)
        self.assertEqual(res.data, serializer.data)

    def test_create_extractor(self):
        """ Test creating extractor """
        payload = {
            'title': 'Sample Extractor',
            'institute_name': 'Big Institute',
            'document_type': 'Ledger Statement',
            'regex_parser': sample_regex_str,
            'reference': reference_str
        }
        res = self.client.post(EXTRACTOR_URL, payload)

        self.assertEqual(res.status_code, status.HTTP_201_CREATED)
        extractor = Extractor.objects.get(id=res.data['id'])

        for key in payload.keys():
            self.assertEqual(payload[key], getattr(extractor, key))

    def test_create_extractor_invalid(self):
        """ Test creating extractor: should fail with missing regex_parser """
        payload = {
            'title': 'Sample Extractor',
            'institute_name': 'Big Institute',
            'document_type': 'Ledger Statement',
            'reference': reference_str
        }
        res = self.client.post(EXTRACTOR_URL, payload)

        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_partial_update_extractor(self):
        """ Test updating a extractor with patch """
        extractor = sample_extractor(user=self.user)

        payload = {
            'title': 'Modified Extractor',
            'institute_name': 'Optionshouse'
        }

        res = self.client.patch(extractor_detail_url(extractor.id), payload)

        extractor.refresh_from_db()

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(extractor.title, payload['title'])
        self.assertEqual(extractor.institute_name, payload['institute_name'])

    def disabled_test_partial_update_extractor_invalid(self):
        """ Test updating a extractor with patch
            We should not allow blank regex
            We should not alllow a malformed regex
        """
        extractor = sample_extractor(user=self.user)

        payload = {
            'title': 'Modified Extractor',
            'regex_parser': ''
        }

        res = self.client.patch(extractor_detail_url(extractor.id), payload)

        extractor.refresh_from_db()

        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
