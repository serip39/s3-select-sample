require 'aws-sdk-s3'

profile_name = 'seri-dev'
bucket_name = 's3-slect-test'

s3_client = Aws::S3::Client.new(profile: profile_name, region: 'ap-northeast-1')

key = 'target_sample.csv'

# サンプル用のデータをアップロードする
s3_client.put_object(bucket: bucket_name, key: key, body: File.read('src/sample.csv'))
