from django.test import TestCase
from django.contrib.auth import get_user_model


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
