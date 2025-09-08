from django.db import models
import uuid

# Create your models here.

class Users(models.Model):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    uname = models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    fcm_token = models.CharField(max_length=2000)
    email = models.CharField(max_length=100)
    age = models.IntegerField()

    def __str__(self):
        return self.uname + "___" + str(self.uid)

class Dining(models.Model):
    did = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    dname = models.CharField(max_length=100)

    def __str__(self):
        return self.dname + "___" + str(self.did)

class Favorites(models.Model):
    fid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    fname = models.CharField(max_length=100)
    # dining = models.ForeignKey(Dining, on_delete=models.CASCADE)
    user = models.ForeignKey(Users, on_delete=models.CASCADE)

    class Meta:
        # This ensures each user can only favorite the same item once
        unique_together = ('user', 'fname')

    def __str__(self):
        return self.fname + "___" + str(self.fid)

class OTP(models.Model):
    code = models.CharField(max_length=6)
    email = models.CharField(primary_key=True, max_length=100)
    created_at_time = models.IntegerField(null=True)

    def __str__(self):
        return self.email + "___" + str(self.code)