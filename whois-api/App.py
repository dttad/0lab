from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
import httpx
import whois
import asyncio

app = FastAPI(title="Domain Lookup API", version="1.0")

# RDAP registry theo TLD
RDAP_REGISTRIES = {
    # gTLDs
    "com": "https://rdap.verisign.com/com/v1/domain/",
    "net": "https://rdap.verisign.com/net/v1/domain/",
    "org": "https://rdap.publicinterestregistry.org/rdap/domain/",
    "info": "https://rdap.afilias.net/rdap/info/domain/",
    "biz": "https://rdap.nic.biz/domain/",
    "io":  "https://rdap.nic.io/domain/",
    "co":  "https://rdap.nic.co/domain/",
    "app": "https://rdap.nic.google/domain/",
    "dev": "https://rdap.nic.google/domain/",
    "page":"https://rdap.nic.google/domain/",
    "ai":  "https://rdap.nic.ai/domain/",
    "me":  "https://rdap.nic.me/domain/",
    "tv":  "https://rdap.verisign.com/tv/v1/domain/",
    "cc":  "https://rdap.verisign.com/cc/v1/domain/",
    "mobi":"https://rdap.afilias.net/rdap/mobi/domain/",
    # ccTLDs - APNIC region
    "au":  "https://rdap.auda.org.au/domain/",
    "jp":  "https://rdap.jprs.jp/domain/",
    "cn":  "https://rdap.cnnic.cn/rdap/domain/",
    "kr":  "https://rdap.kr/domain/",
    "sg":  "https://rdap.sgnic.sg/domain/",
    "vn":  "https://rdap.vnnic.vn/domain/",
    # ccTLDs - RIPE region
    "de":  "https://rdap.denic.de/domain/",
    "uk":  "https://rdap.nominet.uk/uk/",
    "fr":  "https://rdap.nic.fr/domain/",
    "nl":  "https://rdap.sidn.nl/domain/",
    "eu":  "https://rdap.eu/domain/",
    "ru":  "https://rdap.tcinet.ru/domain/",
    "pl":  "https://rdap.dns.pl/domain/",
    "ch":  "https://rdap.nic.ch/domain/",
    "se":  "https://rdap.iis.se/domain/",
    "no":  "https://rdap.norid.no/domain/",
    "dk":  "https://rdap.dk-hostmaster.dk/domain/",
    "fi":  "https://rdap.ficora.fi/domain/",
    "it":  "https://rdap.nic.it/domain/",
    "es":  "https://rdap.nic.es/domain/",
    "be":  "https://rdap.dns.be/domain/",
    "at":  "https://rdap.nic.at/domain/",
    "cz":  "https://rdap.nic.cz/domain/",
    # ccTLDs - ARIN region
    "us":  "https://rdap.arin.net/registry/domain/",
    "ca":  "https://rdap.ca.fury.ca/domain/",
    # ccTLDs - LACNIC region
    "br":  "https://rdap.registro.br/v1/domain/",
    "mx":  "https://rdap.mx/domain/",
    "ar":  "https://rdap.nic.ar/domain/",
    # ccTLDs - AFRINIC region
    "za":  "https://rdap.registry.net.za/domain/",
    "ng":  "https://rdap.nic.net.ng/domain/",
    "ke":  "https://rdap.kenic.or.ke/domain/",
}

RDAP_FALLBACKS = [
    "https://rdap.org/domain/",
    "https://rdap.iana.org/domain/",
]

WHOIS_APIS = [
    lambda d: f"https://who.is/whois-api/{d}",
    lambda d: f"https://api.whoisfreaks.com/v1.0/whois?whois=live&domainName={d}",
    lambda d: f"https://www.whoisxmlapi.com/whoisserver/WhoisService?domainName={d}&outputFormat=JSON",
]


def get_tld(domain: str) -> str:
    parts = domain.lower().strip().split(".")
    # handle SLD ccTLDs like .co.uk, .com.vn, .com.au
    if len(parts) >= 3 and parts[-2] in ("co", "com", "net", "org", "edu", "gov"):
        return f"{parts[-2]}.{parts[-1]}"
    return parts[-1]


async def try_rdap(client: httpx.AsyncClient, url: str, domain: str) -> dict | None:
    try:
        r = await client.get(f"{url}{domain}", timeout=8)
        if r.status_code == 200:
            return {"source": "rdap", "registry": url, "data": r.json()}
    except Exception:
        pass
    return None


async def try_whois_lib(domain: str) -> dict | None:
    try:
        loop = asyncio.get_event_loop()
        data = await loop.run_in_executor(None, whois.whois, domain)
        if data and data.get("domain_name"):
            return {"source": "whois-lib", "data": dict(data)}
    except Exception:
        pass
    return None


async def try_whois_api(client: httpx.AsyncClient, url: str) -> dict | None:
    try:
        r = await client.get(url, timeout=8)
        if r.status_code == 200:
            return {"source": "whois-api", "registry": url, "data": r.json()}
    except Exception:
        pass
    return None


@app.get("/lookup/{domain}", summary="Lookup domain info via RDAP + WHOIS fallback")
async def lookup(domain: str):
    domain = domain.lower().strip()
    tld = get_tld(domain)

    async with httpx.AsyncClient(follow_redirects=True) as client:

        # 1. Thử registry cụ thể theo TLD
        if tld in RDAP_REGISTRIES:
            result = await try_rdap(client, RDAP_REGISTRIES[tld], domain)
            if result:
                return result

        # 2. Fallback RDAP tổng hợp
        for fb in RDAP_FALLBACKS:
            result = await try_rdap(client, fb, domain)
            if result:
                return result

        # 3. Fallback python-whois
        result = await try_whois_lib(domain)
        if result:
            return result

        # 4. Fallback WHOIS API online
        for api_fn in WHOIS_APIS:
            result = await try_whois_api(client, api_fn(domain))
            if result:
                return result

    raise HTTPException(status_code=404, detail=f"Could not fetch info for '{domain}' from any source.")


@app.get("/health")
async def health():
    return {"status": "ok"}