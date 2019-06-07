from django.test import TestCase
from django.contrib.auth import get_user_model

from core.models import Tag, Extractor


# Used for tag testing
def sample_user(email="test@abc.com", password="Test123"):
    """ Create a sample user """
    return get_user_model().objects.create_user(email, password)


# Used for extractor testing

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


class ModelTests(TestCase):

    def test_create_user_with_email_successful(self):
        """ Create a new user """
        email = "neeraj@abc.com"
        password = "Neeraj123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """ Test the email is normalized for new user """
        email = "neeraj@FINNIRV.COM"
        user = get_user_model().objects.create_user(email, 'test123')

        self.assertEqual(user.email, email.lower())

    def test_new_user_invalid_email(self):
        """ Users with no email should cause error """
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None, 'test123')

    def test_create_new_superuser(self):
        """ Test creation of a superuser """
        user = get_user_model().objects.create_superuser(
            'admin@abc.com',
            'Admin123'
        )

        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)

    def test_tag_str(self):
        """ Test the tag string representation """
        tag = Tag.objects.create(
            user=sample_user(),
            name='Vegan'
        )

        self.assertEqual(str(tag), tag.name)

    def test_extractor_str(self):
        """ Test the recipe string representation """
        extractor = Extractor.objects.create(
            user=sample_user(),
            title='HDFCBank Savings Statement Parser',
            institute_name='HDFCBank',
            document_type='SavingsAccountStatement',
            regex_parser=sample_regex_str,
            reference=reference_str,
        )

        self.assertEqual(str(extractor), extractor.title)
