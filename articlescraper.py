from bs4 import BeautifulSoup
import ssl
import urllib
import os, csv
os.chdir("\Users\MLH\Desktop")

# Temporary fix from http://stackoverflow.com/questions/27835619/ssl-certificate-verify-failed-error
gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1)

def find_article_urls(pageURL):
    r = urllib.urlopen(pageURL, context=gcontext).read()
    soup = BeautifulSoup(r, 'html.parser')
    articles = soup.find_all("article")

    urls = []
    for element in articles:
        url = element.a["href"]
        urls.append(url)
    return urls

def homepage_urls(pages):
    if pages == 0:
        return
    urls = ["https://theblackandbluejay.com/"]
    for i in range(1, pages):
        urls.append("https://theblackandbluejay.com/page/" + str(i) + "/")
    return urls

def find_articles_up_to_page(num):
    articleURLs = []
    for page in homepage_urls(10):
        for url in find_article_urls(page):
            articleURLs.append(url)
    return articleURLs

### Database format: image_url, title, publisher_id, content, article_type, date_published
def article_to_database_entry(url):
    
    r = urllib.urlopen(url, context=gcontext).read()
    soup = BeautifulSoup(r, 'html.parser')

    image_query = soup.find("img", class_="wp-post-image")
    if (image_query != None):
        image_url = soup.find("img", class_="wp-post-image")["src"]
        if (image_url.find("?") != -1):
            image_url = image_url[0:image_url.find("?")]
    else:
        image_url=""
    title = soup.find("h1", class_="page-title").get_text()
    publisher_id = 9
    

    article = []
    articleBody = soup.find("div", class_="entry-content")
    paragraphs = articleBody.findAll("p")
    for para in paragraphs:
        article.append(para.get_text())
    article_type = 3
    date_published = soup.find("time", class_="entry-date")["datetime"][0:10] + " 00:00:00"

    content = "\n".join(article)
    return [image_url, title, publisher_id, content, article_type, date_published]

#### Testing grounds
def pull_bbj_hist():
    entries = []
    entries.append(article_to_database_entry("https://theblackandbluejay.com/2015/10/14/people-who-just-read-playboy-for-the-articles-finally-vindicated/"))
    entries.append(article_to_database_entry("https://theblackandbluejay.com/2017/02/08/25-alternative-facts-with-sean-spicer/"))
    '''for url in find_articles_up_to_page(10):
        entries.append(article_to_database_entry(url))
        print len(entries)
    print len(entries)'''
    return entries

def add_article_to_database(entry):
    cursor.execute("INSERT INTO Article VALUES (?,?,?,?,?,?)", entry);

