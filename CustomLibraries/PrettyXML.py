import xml.dom.minidom
import re

def pretty_print_xml(xmlinput):
    xmlparsed = xml.dom.minidom.parseString(xmlinput)

    xmlpretty = xmlparsed.toprettyxml()

    return xmlpretty

# use this keyword to remove all spaces, tabs and new lines after a '>' symbol (or after each tag in xml)
def remove_spaces(text):

    text2 = re.sub(r'([>])\s+', r'\1', text)

    return text2

def clean_cdata(xml):
    cleanxml = xml.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&").replace("&apos;", "'").replace("&quot;", '"')
    return cleanxml

