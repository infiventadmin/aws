## Zip File 

```zip -r <functionName>.zip index.js node_modules package.json .env```


## Upload to S3

```aws s3 cp <functionName>.zip s3://infivent-sample-deployment-bucket/```

## Update Function

```aws lambda update-function-code --function-name <functionName> --zip-file fileb://<functionName>.zip```

## Test via invoke

```aws lambda invoke --function-name getUsersFromPostgres response.json```


## Terraform 

1. Edit main.tf
2. Add Function Name and config
3. Zip files
4. Upload files to s3
5. run ```terraform plan```
6. run  ```terraform apply``` to apply and deploy configs
7. Check all subnets and security groups
8. test via invoke.
