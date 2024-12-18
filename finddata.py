import pandas as pd

#replace this with the filepath on ur machine
path = "C:/Users/Brandon/Repositories/ECGSignalProcessing/data/subject-info.csv"
temp = input('What age group?')
ageGroup = int(temp)

df = pd.read_csv(path)

filtered_ids = df[(df['Age_group'] == ageGroup) & (df['Device'] == 0)]['ID']

filtered_list = filtered_ids.tolist()
print(filtered_list)
