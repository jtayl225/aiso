# import os
# from flask import Flask, flash, render_template, redirect, request
# from tasks import add

# app = Flask(__name__)
# app.secret_key = os.getenv('FLASK_SECRET_KEY', "super-secret")


# @app.route('/')
# def main():
#     return render_template('main.html')


# @app.route('/add', methods=['POST'])
# def add_inputs():
#     x = int(request.form['x'] or 0)
#     y = int(request.form['y'] or 0)
#     add.delay(x, y)
#     flash("Your addition job has been submitted.")
#     return redirect('/')

import os
from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from tasks import add

app = FastAPI()

# Set up Jinja2 templates
templates = Jinja2Templates(directory="templates")

# Optional: for serving static files if needed
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/", response_class=HTMLResponse)
def main(request: Request, msg: str = None):
    return templates.TemplateResponse("main.html", {"request": request, "msg": msg})


@app.post("/add")
def add_inputs(x: int = Form(0), y: int = Form(0)):
    add.delay(x, y)
    # Redirect back to / with a success message
    return RedirectResponse(url="/?msg=Your+addition+job+has+been+submitted", status_code=303)
