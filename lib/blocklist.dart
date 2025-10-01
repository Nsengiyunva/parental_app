class Blocklist {
  final List<String> domains = [
    'pornhub.com',
    'xvideos.com',
    'redtube.com',
    'adultfriendfinder.com',
    'gambling.com',
    '18only.com',
  ];

  void addDomain(String domain) {
    if (!domains.contains(domain)) domains.add(domain);
  }

  void removeDomain(String domain) {
    domains.remove(domain);
  }
}
