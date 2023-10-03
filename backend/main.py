# Import the 'api' function from the 'api' module
from rest_api.api import api

# Check if this script is being run as the main program
if __name__ == "__main__":
    # Call the 'api' function to start the FastAPI application
    api()
