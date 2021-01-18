def get_name(body):
    return body.find('span', {'class':'lng_cont_name'}).string

def which_digit(html):
    mappingDict={'icon-ji':9,
                'icon-lk':8,
                'icon-nm':7,
                'icon-po':6,
                'icon-rq':5,
                'icon-ts':4,
                'icon-vu':3,
                'icon-wx':2,
                'icon-yz':1,
                'icon-acb':0,
                }
    return mappingDict.get(html,'')

def get_phone_number(body):
    i=0
    phoneNo = "No Number!"
    try:
            
        for item in body.find('p',{'class':'contact-info'}):
            i+=1
            if(i==2):
                phoneNo=''
                try:
                    for element in item.find_all(class_=True):
                        classes = []
                        classes.extend(element["class"])
                        phoneNo+=str((which_digit(classes[1])))
                except:
                    pass
    except:
        pass
    
    return phoneNo

def get_rating(body):
    return body.find('span', {'class':'green-box'}).string

def get_rating_count(body):
    text = body.find('span', {'class':'rt_count'}).string

    # Get only digits
    rating_count =''.join(i for i in text if i.isdigit())
    return rating_count

def get_address(body):
    return body.find('span', {'class':'mrehover'}).text.strip()
