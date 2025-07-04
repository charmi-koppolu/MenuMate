# Generated by Django 5.2.3 on 2025-06-14 01:09

import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Users",
            fields=[
                (
                    "uid",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                    ),
                ),
                ("uname", models.CharField(max_length=100)),
                ("password", models.CharField(max_length=100)),
                ("token", models.CharField(max_length=100)),
                ("email", models.CharField(max_length=100)),
                ("age", models.IntegerField()),
            ],
        ),
    ]
