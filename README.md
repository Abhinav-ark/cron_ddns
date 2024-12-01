# Cron DDNS
A Cron based Bash script for `linux` systems to periodically update Cloudflare DNS records.

## How to setup?
1. You need a `Cloudflare Domain` (or) transfer your Domain to [Cloudflare](https://developers.cloudflare.com/registrar/get-started/transfer-domain-to-cloudflare/).
   
2. Get the [API Key](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) and [ZoneID](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/) from Cloudflare Dashboard.

3. Get the `RECORD ID` for the subdomain you want to manage.

Use Cloudflare API to get record `id` from your desired record.
```bash
curl --request GET \
--url https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/dns_records \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <API_KEY>'
```

4. Install cron on the system if not already present

If you are using Ubuntu
```bash
apt-get update && apt-get upgrade
```
```bash
apt-get install cron
```
Verify your installation using
```bash
systemctl status cron
```

5. Clone this Repository.
```git
git clone https://github.com/Abhinav-ark/cron_ddns.git
```

6. create a `.env` file and add the env variables specified below.
```bash
touch .env
```

7. Run main.bash
```bash
bash main.bash
```

## .env File Format
```.env
API_KEY="<cloudflare_api_key>"
ZONE_ID="<cloudflare_zone_id>"
RECORD_ID="<dns_record_id>"
DNS_NAME="<domain_name>"
IP_FILE="<path_to_store_last_updated_ip>"
LOG_FILE="<path_to_store_ddns_logs>"
```
