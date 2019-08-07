from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, \
                                        PermissionsMixin

from django.conf import settings





class UserManager(BaseUserManager):

    def create_user(self, email, password=None, **extra_fields):
        """ Create and save a new user """
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, email, password=None):
        """ Create and save a new superuser """
        user = self.create_user(email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)

        return user


class User(AbstractBaseUser, PermissionsMixin):
    """ Custom user model for supporting email instead of username """
    email = models.EmailField(max_length=255, unique=True)
    name = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'


class Tag(models.Model):
    """ Tag to be used for a recipe """
    name = models.CharField(max_length=255)
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )

    def __str__(self):
        return self.name


class Extractor(models.Model):
    """ Extractor object """
    title = models.CharField(max_length=255)
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    institute_name = models.CharField(max_length=255, blank=False)
    document_type = models.CharField(max_length=255, blank=False)

    regex_parser = models.CharField(max_length=2048, blank=False)
    reference = models.CharField(max_length=512, blank=True)

    def __str__(self):
        return self.title


class Schema(models.Model):
    """ Extractor object """
    title = models.CharField(max_length=255)
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )

    fields_json = models.CharField(max_length=2048, blank=False)

    def __str__(self):
        return self.title


class Document(models.Model):
    """ Extractor object """
    title = models.CharField(max_length=255)
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    institute_name = models.CharField(max_length=255, blank=False)
    document_type = models.CharField(max_length=255, blank=False)

    text = models.TextField()
    highlighted = models.TextField(default="")
    transactions_json = models.TextField(default="")

    def __str__(self):
        return self.title


from django.db import connection


class File(models.Model):
    title = models.CharField(blank=True, max_length=255)
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        blank=True,
    )
    institute_name = models.CharField(max_length=255, blank=True)
    document_type = models.CharField(max_length=255, blank=True)

    file = models.FileField(blank=False, null=False)
    password = models.CharField(max_length=64, blank=True)
    remark = models.CharField(max_length=20)
    timestamp = models.DateTimeField(auto_now_add=True)
    text = models.TextField()

    def __str__(self):
        return self.title

    # https://stackoverflow.com/questions/4532681/how-to-remove-all-of-the-data-in-a-table-using-django
    def delete_all(self):
        self.__class__.objects.all().delete()

    def drop_table(self):
        cursor = connection.cursor()
        table_name = self.__class__._meta.db_table
        sql = "DROP TABLE %s;" % (table_name, )
        cursor.execute(sql)


class Transaction(models.Model):
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        blank=True,
        default="alice@abc.com",
    )

    # https://medium.com/@krishnaregmi/handling-model-relationships-in-django-rest-framework-e0dfbcf1d83e
    doc = models.ForeignKey(Document,
                            on_delete=models.CASCADE,
                            default=None,
                            related_name = 'transactions',)

    TradeDate = models.DateTimeField(blank=False)
    Scrip = models.CharField(max_length=64, blank=True)
    Symbol = models.CharField(max_length=64, blank=True)
    SettleDate = models.DateTimeField(blank=False)
    TradeQuantity = models.DecimalField(decimal_places=2, max_digits=10)
    # TradeType = models.ChoiceField(choices=["BUY", "SELL"]) # Kept for future
    TradeType = models.CharField(max_length=16)
    PrincipalAmount = models.DecimalField(decimal_places=4, max_digits=20)
    Commission = models.DecimalField(decimal_places=4, max_digits=10, blank=True, default=0.0)
    Fees = models.DecimalField(decimal_places=4, max_digits=10, blank=True, default=0.0)
    NetAmount = models.DecimalField(decimal_places=4, max_digits=20)

    def __str__(self):
        return '%d: %s' % (self.id, self.Scrip)


OPERATIONS_CHOICES = (
    ('Extract', 'Extract'),
    ('Transform', 'Transform'),
    ('Load', 'Load')
)


class Operation(models.Model):
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        blank=True,
        default="alice@abc.com",
    )
    title = models.CharField(max_length=128, blank=False)
    type = models.CharField(max_length=32, choices=OPERATIONS_CHOICES, blank=False)
    parameters = models.CharField(max_length=2048)

    def __str__(self):
        return self.title


# This table witll
class DatastoreType(models.Model):
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        blank=True,
        default="alice@abc.com",
    )
    title = models.CharField(max_length=128, blank=False)
    parameters = models.CharField(max_length=2048)


class Pipeline(models.Model):
    user = models.ForeignKey(
        # We could have user User below, but using settings is a better way
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        blank=True,
        default="alice@abc.com",
    )
    institute_name = models.CharField(max_length=255, blank=False)
    document_type = models.CharField(max_length=255, blank=False)
    title = models.CharField(max_length=128, blank=False)
    operations = models.ManyToManyField('Operation')
