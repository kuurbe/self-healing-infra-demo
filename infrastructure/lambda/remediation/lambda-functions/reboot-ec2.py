import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = "INSTANCE_ID"  # Replace with actual or dynamically pass in
    ec2.reboot_instances(InstanceIds=[instance_id])
    return {
        'statusCode': 200,
        'body': f'Reboot command sent to {instance_id}'
    }