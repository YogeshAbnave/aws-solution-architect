#!/usr/bin/env python3

import random
import logging
from argparse import ArgumentParser
from datetime import timedelta, datetime
import itertools

# Function to parse command-line options
def read_options():
    parser = ArgumentParser(description="Generate simulated logs for legitimate users and DDoS attacks.")
    parser.add_argument("-t", "--time", dest="duration", type=int, default=48,
                        help="Generate logs for X hours. Default=48H (2 days)")
    parser.add_argument("-l", "--legit-connection", dest="legal", type=int, default=1000,
                        help="Number of legal users connecting. Default=1000")
    parser.add_argument("-s", "--start-ddos", dest="start", type=int, default=24,
                        help="Start DDoS after X hours. Default=24H")
    parser.add_argument("-d", "--ddos-connection", dest="ddos", type=int, default=10000,
                        help="Number of DDoS connections. Default=10000")
    parser.add_argument("-i", "--increment", dest="increment", type=int, default=60,
                        help="Generate logs every X minutes. Default=60min")
    parser.add_argument("-f", "--logfile", dest="logfile", type=str, default="/var/log/kafka/event.log",
                        help="Specify a log file. Default=/var/log/kafka/event.log")
    return parser.parse_args()

# Function to generate a random IP address
def random_ip():
    reserved_ranges = {10, 127, 169, 172, 192}
    first_octet = random.choice([i for i in range(1, 256) if i not in reserved_ranges])
    return f"{first_octet}.{random.randint(1, 255)}.{random.randint(1, 255)}.{random.randint(1, 255)}"

# Function to pick a country based on weighted probabilities
def weighted_pick(d):
    total_weight = sum(d.values())
    cumulative_weights = list(itertools.accumulate(d.values()))
    r = random.uniform(0, total_weight)
    for k, cw in zip(d.keys(), cumulative_weights):
        if r < cw:
            return k
    return next(iter(d))

# Function to generate countries based on user activity
def weight_good_country(user):
    countries = {
        'US': 30, 'GB': 10, 'DE': 8, 'FR': 5, 'CA': 7, 'AU': 7, 
        'IT': 5, 'ES': 5, 'NL': 4, 'SE': 4, 'CH': 3, 'BE': 2, 
        'AT': 2, 'DK': 2, 'NO': 2, 'FI': 2, 'NZ': 2, 'IE': 2, 'SG': 2, 'HK': 2
    }
    return [weighted_pick(countries) for _ in range(user)]

def weight_bad_country(user):
    countries = {
        'CN': 20, 'IN': 15, 'RU': 12, 'BR': 10, 'MX': 8, 'KR': 7, 
        'PK': 5, 'TR': 5, 'VN': 4, 'TH': 4, 'PH': 3, 'ID': 3, 
        'IR': 3, 'MY': 3, 'SA': 2, 'EG': 2, 'AR': 2, 'UA': 2, 'CO': 2, 'ZA': 2
    }
    return [weighted_pick(countries) for _ in range(user)]

# Main function to generate logs
def main():
    options = read_options()
    
    # Configure logging
    logging.basicConfig(
        filename=options.logfile,
        format='%(message)s',
        level=logging.INFO
    )

    start_time = datetime.now() - timedelta(hours=options.duration)
    attack_time = start_time + timedelta(hours=options.start)
    end_time = start_time + timedelta(hours=options.duration)

    current_time = start_time
    while current_time < end_time:
        timestamp = current_time.strftime("%Y-%m-%dT%H:%M:%S")
        for country in weight_good_country(random.randint(1, options.legal)):
            logging.info(f"{timestamp} | {random_ip()} | {country} | SUCCESS")
        if current_time >= attack_time:
            for country in weight_bad_country(random.randint(1, options.ddos)):
                logging.info(f"{timestamp} | {random_ip()} | {country} | ERROR")
        current_time += timedelta(minutes=options.increment)

if __name__ == "__main__":
    main()
