Back to the tools. You need to configure s3cmd (the command line utility from the S3 Tools project) like so:

s3cmd --configure

It will walk you through adding your Amazon credentials and GPG information if you want to encrypt files while stored on S3. Amazon's storage is supposed to be private, but you should always assume that data stored on remote servers is potentially visible to others. Since I'm storing information that has no real need for privacy (WordPress backups, MP3s, photos that I'd happily publish online anyway) I don't worry overmuch about encrypting for storage on S3.

There's another advantage of foregoing GPG encryption, which is that s3cmd can use an rsync-like algorithm for syncing files instead of just re-copying everything.

Now to copy files and use s3cmd sync. You'll find that the s3cmd syntax mimics standard *nix commands. Want to see what is being stored in your S3 account? Use s3cmd ls to show all buckets. (Amazon calls 'em buckets instead of directories.)

Want to copy between buckets? Use s3cmd cp bucket1bucket2. Note that buckets are specified by the syntax s3://bucketname.

To put files in a bucket, use s3cmd put filenames3://bucket. To get files, use s3cmd get filenamelocal. To upload directories, you need to use the --recursive option.

But if you want to sync files and save yourself some trouble down the road, there's the sync command. It's dead simple to use:

s3cmd sync directorys3://bucket/

The first time, it will copy up all files. The next time it will only copy up files that don't already exist on Amazon S3. However, if you want to get rid of files that you have removed locally, use the --delete-removed option. Note that you should test this with the --dry-run option first. You can accidentally delete files that way.

It's pretty simple to use s3cmd, and you should look at its man page as well. It even has some support for the CloudFront CDN service if you need that. Happy syncing!
