#!/usr/bin/env python3
import os
import csv
import ssl
from Scripts import actions
import pip
import pkg_resources

# necessary packages
names = {'tk','bs4','requests','requests-oauthlib','urllib3','Pillow'}

installed = {pkg.key for pkg in pkg_resources.working_set}
missing = names - installed

if missing:
    for package in missing:
        if hasattr(pip, 'main'):
            pip.main(['install', package])
        else:
            pip._internal.main(['install', package])


from tkinter import *
import tkinter
from tkinter.filedialog import askdirectory
from tkinter.font import BOLD
from bs4 import BeautifulSoup
import urllib
import urllib.request

root = Tk()
root.geometry("880x680")
root.minsize(644,434)
root.configure(background='black')
root.title('JustDial Scraper - Educational Purpose Only')

curretnDir = os.path.dirname(os.path.realpath(__file__))

def clear_entry(event, entry):
    entry.delete(0, END)
    result['text'] = ''
    
def startClick():
    global url, rename
    url = link.get()
    rename = name.get()
    getStarted(url,rename)


def getStarted(url,name):

    if 'downloads' not in os.listdir(curretnDir):
        path = os.path.join(curretnDir,"downloads")
        os.mkdir(path)
    else:
        pass
    
    ac = actions.GetAction()
    
    page_number = 1
    service_count = 1
    ssl._create_default_https_context = ssl._create_unverified_context

    fields = ['Name', 'Phone', 'Rating', 'Rating Count', 'Address']
    out_file = open(curretnDir+'downloads/'+str(name)+'.csv','w')
    hdr = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)' }
    csvwriter = csv.DictWriter(out_file, delimiter=',', fieldnames=fields)

    # Write fields first
    csvwriter.writerow(dict((fn,fn) for fn in fields))
    
    status = True
    while status:

        # check end of page
        if page_number > 50:
            status = False

        req = urllib.request.Request(url, headers=hdr)
        page=urllib.request.urlopen(req)

        soup = BeautifulSoup(page.read(), "html.parser")
        services = soup.find_all('li', {'class': 'cntanr'})
        
        for service_html in services:

            dict_service = {}
            dict_service['Name'] = ac.get_name(service_html)
            dict_service['Phone'] = ac.get_phone_number(service_html)
            dict_service['Rating'] = ac.get_rating(service_html)
            dict_service['Rating Count'] = ac.get_rating_count(service_html)
            dict_service['Address'] = ac.get_address(service_html)
            
            csvwriter.writerow(dict_service)
            
            service_count += 1

        page_number += 1

    out_file.close()
    if status == False:
        result['text'] = 'Downloaded at '+curretnDir+'downloads/'+name+'.csv'

top = PhotoImage(file=curretnDir+'/assets/front.png')
top_image=Label(image=top)
top_image.pack()

# Create text widget and specify size.
T = Text(root, height = 10, width = 100, bg='black', fg='white', bd=0)

# Create label
l = Label(root, font=("HelvLight",22, BOLD), bg='black', fg='white', text = "       Instructions")
  
Fact = """        1. Open www.justdial.com
        2. Select location and search type and click on search
        3. Copy the link from address bar and paste in the link section
        4. Name the file and click on Download. 

        ** Don't panic if it shows not responding **

        Watch the tutorial
        https://www.niladrihere.me"""
l.pack(pady=(20,0), side=TOP, anchor=W)

T.insert(tkinter.END,Fact)
T.pack(pady=(0,10), side=TOP, anchor=W)

link = Entry(root, font=("HelvLight",16), width = 62, bg = 'grey', borderwidth=0)
link.insert(0, "Enter the link (please follow guide for the link)")
link.pack(padx=10, pady=(0,25),ipady=4)
link.bind("<Button-1>", lambda event: clear_entry(event, link))

name = Entry(root, font=("HelvLight",16), width = 45, bg = 'grey', borderwidth=0)
name.insert(0, "File name (without extension)")
name.pack(padx=10, pady=(0,15),ipady=4)
name.bind("<Button-1>", lambda event: clear_entry(event, name))

start_button = PhotoImage(file=curretnDir+'/assets/down.png')
myStart = Button(root, image=start_button, command=startClick, borderwidth=0)
myStart.config(highlightbackground='black', highlightcolor= 'black')
myStart.pack(pady=18)

result = Label(root, font=("HelvLight",12), bg='black', fg='white', text="")
result.pack()

root.mainloop()