import difflib

def show_differences(text1, text2):

    d = difflib.Differ()

    diff = list(d.compare(text1.split('><'), text2.split('><')))

    differences = []

    for i in diff:
        if i[0] == '+':
            differences.append(i)
        elif i[0] == '-':
            differences.append(i)

    print(differences)

    return differences
