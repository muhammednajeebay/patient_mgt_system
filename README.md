# patient_mgt_system

# Flutter Test Case (1)

This provides simple APIs to manage an Ayurvedic Centre Patients The following resources are available along with the details of the HTTP methods they support.

❖ Base URL : https://flutter-amr.noviindus.in/api/

❖ Figma:https://www.figma.com/file/JxD3JWZHGKsoeZy1Q3tnRE/Flutter-Machine-Test-Design?type=design&node-id=0%3A1&mode=design&t=uYBaQGoxRTZ8Dwdg-1

## Login:
● In order to get the access the user must login to the App

● At the time of login, you will get a Token. This Token must be used in all other API's.

● Remember to pass the keys in Formdata

Noviindus Technologies

API : Login [POST]

● Keys:
1. username : test_user
2. password : 12345678

## Patient List:
● From this API you will get a list of patients.

● This will be shown in your home page (If the list is empty show empty list image).

● Page should refresh when user pulls down the screen

API : PatientList [GET]

## Register Patient
● Use this API to register a new patient.

● Treatment list and branch list can be get from last two APIs

● You should add static locations to the Location Dropdown

● After submitting this form you should generate a pdf with those details in the format given in the figma.

Noviindus Technologies

API : PatientUpdate [POST]

● Keys:
1. name (String)
2. excecutive (String)
3. payment (String)
4. phone (String)
5. address (String)
6. total_amount (double)
7. discount_amount (double)
8. advance_amount (double)
9. balance_amount (double)
10. date_nd_time (String eg:01/02/2024-10:24 AM)
11. id (Pass empty string to this key)
12. male (List of selected treatment ids separated by commas eg: 2,3,4)
13. female (List of selected treatment ids separated by commas eg: 2,3,4)
14. branch
15. treatments (List of selected treatment ids separated by commas eg: 2,3,4)

## Branch List
● From this API you will get a list of branches.

API : BranchList [GET]

Noviindus Technologies

## Treatment List
● From this API you will get a list of treatments.

API : TreatmentList [GET]

## In addition to this, please ensure the following:
1. Use a clean architecture approach.(Provider state management preferred)
2. Use git to version control your project and put it on Github, GitLab
3. Minimise usage of 3rd party packages
4. Make the UI minimally attractive.
5. Make the code base production-ready.

Noviindus Technologies

## We expect to receive the following :
1. The source code on a git hosting website. The entire application should not be a single commit. We want to see how the process of development took place.
2. An apk built off this code base. Please upload this to a cloud hosting services like Google Drive, Dropbox, etc.
3. Screenshots (directly attach to email)

If you have any suggestions about the API, please email or whatsapp to us. We will not be making any changes now but good suggestions will be positive during your application process.

Noviindus Technologies