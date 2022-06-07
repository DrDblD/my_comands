import xmltodict
# import pprint

my_xml = open('/home/atab/repos/jira_poidem/main-jira-back/activeobjects.xml', 'r').read()
# pp = pprint.PrettyPrinter(indent=4)

old_jira=xmltodict.parse(
    open('/home/atab/repos/jira_poidem/main-jira-back/entities.xml', 'r').read())
new_jira=xmltodict.parse(
    open('/home/atab/repos/jira_poidem/stand-jira-back/entities.xml', 'r').read())


# import dictdiffer
# import json

# with open('diff.txt','w') as f:
#     f.write(json.dumps(list(dictdiffer.diff(old_jira,new_jira))))

# from pprint import pprint
from deepdiff import DeepDiff
import yaml

def del_row(d=dict()):
    if d.get('row'):
        print(d.pop('row', None))
    for key in d:
        d[key] = del_row(d[key]) if type(d[key]) == type({}) else d[key]
    return d

old_jira = del_row(old_jira)
new_jira = del_row(new_jira)
with open('diff.txt','w') as f:
    # pprint(DeepDiff(old_jira,new_jira), f, indent=2)
    yaml.dump(DeepDiff(old_jira,new_jira),f)
    # yaml.dump(old_jira,f)