# Generated by Django 2.1.9 on 2019-06-14 09:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0007_file_text'),
    ]

    operations = [
        migrations.AddField(
            model_name='file',
            name='password',
            field=models.CharField(blank=True, max_length=64),
        ),
    ]
