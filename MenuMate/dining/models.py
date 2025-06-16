from django.db import models
import uuid

# Create your models here.

class Users(models.Model):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    uname = models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    token = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    age = models.IntegerField()

    def __str__(self):
        return self.uname + "___" + str(self.uid)

class Dining(models.Model):
    did = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    dname = models.CharField(max_length=100)

    def __str__(self):
        return self.dname + "___" + str(self.did)