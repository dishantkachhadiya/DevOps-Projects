#!/bin/bash
rsync -avz -e "ssh -i ~/.ssh/server-key1" ./static-site/ ubuntu@13.62.104.83:/var/www/static-site/
