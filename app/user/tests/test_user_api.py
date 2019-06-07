from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse

from rest_framework.test import APIClient
from rest_framework import status


CREATE_USER_URL = reverse('user:create')
TOKEN_URL = reverse('user:token')
# ME_URL = reverse('user:me')


def create_user(**params):
    return get_user_model().objects.create_user(**params)


class PublicUserApiTests(TestCase):
    """ Test the APIs which don't require authentication """

    def setUp(self):
        self.client = APIClient()

    def test_create_valid_user_success(self):
        """ Test create user with valid payload """
        payload = {
            'email': 'test@abc.com',
            'password': 'Test123',
            'name': 'Test name'
        }
        res = self.client.post(CREATE_USER_URL, payload)

        self.assertEqual(res.status_code, status.HTTP_201_CREATED)
        user = get_user_model().objects.get(**res.data)
        self.assertTrue(user.check_password(payload['password']))
        self.assertNotIn('password', res.data)

    def test_create_already_existing_user(self):
        """ Test creating a user which is already created """

        payload = {'email': 'test@abc.com', 'password': 'Test123'}

        # First time we are directly creating user
        create_user(**payload)

        # Second time we are craeting user via API client
        res = self.client.post(CREATE_USER_URL, payload)

        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_password_too_short(self):
        """ Test that password is atleast 6 characters """
        payload = {'email': 'test@abc.com', 'password': 'pw'}
        res = self.client.post(CREATE_USER_URL, payload)

        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
        user_exists = get_user_model().objects.filter(
            email=payload['email']
        ).exists()
        self.assertFalse(user_exists)

    def test_create_token_for_user(self):
        """ Test that a token is created for a user """
        payload = {'email': 'test@abc.com', 'password': 'Test123'}
        create_user(**payload)
        res = self.client.post(TOKEN_URL, payload)

        self.assertIn('token', res.data)
        self.assertEqual(res.status_code, status.HTTP_200_OK)

    def test_create_token_invalid_credentials(self):
        """ Test that token is not created for invalid credentials"""
        create_user(email='test@abc.com', password='Test123')
        payload = {'email': 'test@abc.com', 'password': 'Wrong'}
        res = self.client.post(TOKEN_URL, payload)

        self.assertNotIn('token', res.data)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_token_no_user(self):
        """ Test that token is not create if user doesn't exist """
        payload = {'email': 'test@abc.com', 'password': 'Test123'}
        res = self.client.post(TOKEN_URL, payload)

        self.assertNotIn('token', res.data)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_token_blank_password(self):
        create_user(email='test@abc.com', password='Test123')
        payload = {'email': 'test@abc.com', 'password': ''}
        res = self.client.post(TOKEN_URL, payload)

        self.assertNotIn('token', res.data)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    # def test_retrieve_user_unauthorized(self):
    #     """ Test that authentication is required for users """
    #     res = self.client.get(ME_URL)
    #
    #     self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)


# class PrivateUserApiTests(TestCase):
#     """ Test APIs that require user authentication """
#
#     def setUp(self):
#         self.user = create_user(
#             email='test@abc.com',
#             password='Test123',
#             name='Test',
#         )
#         self.client = APIClient()
#         self.client.force_authenticate(user=self.user)
#
#     def test_retrieve_profile_success(self):
#         """ Test retrieving profile of logged in user """
#         res = self.client.get(ME_URL)
#
#         self.assertEqual(res.status_code, status.HTTP_200_OK)
#         self.assertEqual(res.data, {
#             'name': self.user.name,
#             'email': self.user.email
#         })
#
#     def test_post_me_not_allowed(self):
#         """ Test that POST is not allowed on the me url """
#         res = self.client.post(ME_URL, {})
#
#         self.assertEqual(res.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
#
#     def test_update_user_profile(self):
#         """ Test updating user profile for authenticated user """
#
#         payload = {'name': 'New Name', 'password': 'newpass'}
#         res = self.client.patch(ME_URL, payload)
#
#         self.user.refresh_from_db()
#         self.assertEqual(self.user.name, payload['name'])
#         self.assertTrue(self.user.check_password(payload['password']))
#         self.assertEqual(res.status_code, status.HTTP_200_OK)
