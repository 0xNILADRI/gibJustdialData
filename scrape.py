import os
import csv
import ssl
import time
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from actions import *
from bs4 import BeautifulSoup
import urllib
import urllib.request



root = Tk()
root.geometry("880x594")
root.minsize(644,434)
root.configure(background='black')
root.title('JustDial Scraper - Educational Purpose Only')


def clear_entry(event, entry):
    entry.delete(0, END)
    result['text'] = ''
    
def startClick():
    global url, rename
    url = link.get()
    rename = name.get()
    getStarted(url,rename)

def getStarted(url,name):

    if 'downloads' not in os.listdir(os.getcwd()):
        os.mkdir('downloads')
    else:
        pass

    
    page_number = 1
    service_count = 1
    ssl._create_default_https_context = ssl._create_unverified_context

    fields = ['Name', 'Phone', 'Rating', 'Rating Count', 'Address']
    out_file = open('downloads/'+str(name)+'.csv','w')
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
            dict_service['Name'] = get_name(service_html)
            dict_service['Phone'] = get_phone_number(service_html)
            dict_service['Rating'] = get_rating(service_html)
            dict_service['Rating Count'] = get_rating_count(service_html)
            dict_service['Address'] = get_address(service_html)
            
            csvwriter.writerow(dict_service)
            
            service_count += 1

        page_number += 1

    out_file.close()
    if status == False:
        result['text'] = 'Successfully Downloaded!' + ' Go to '+ os.getcwd()+'/downloads/'+name+'.csv'


top = PhotoImage(file='assets/front.png')
top_image=Label(image=top)
top_image.pack()

link = Entry(root, font=("Open Sans",18), width = 65, bg = 'grey', borderwidth=0)
link.insert(0, "Please enter Justdial Wesite, with the category page as a subcategory")
link.pack(padx=10, pady=(90,35),ipady=4)
link.bind("<Button-1>", lambda event: clear_entry(event, link))

name = Entry(root, font=("Open Sans",18), width = 45, bg = 'grey', borderwidth=0)
name.insert(0, "Rename your file as (without extension)")
name.pack(padx=10, pady=(0,15),ipady=4)
name.bind("<Button-1>", lambda event: clear_entry(event, name))

start_button = PhotoImage(file='assets/down.png')
myStart = Button(root, image=start_button, command=startClick, borderwidth=0)
myStart.config(highlightbackground='black', highlightcolor= 'black')
myStart.pack(pady=35)

result = Label(root, font=("Open Sans",18), bg='black', fg='white', text="")
result.pack()

root.mainloop()
