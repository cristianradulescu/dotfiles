function FindProxyForURL(url, host) {
    var dominated = [
        // Domains that  are only accessible through the VPN and should use the proxy
        "example.com",
    ];

    for (var i = 0; i < dominated.length; i++) {
        if (dnsDomainIs(host, dominated[i]) ||
            dnsDomainIs(host, "." + dominated[i])) {
            return "SOCKS5 localhost:1080";
        }
    }

    return "DIRECT";
}
