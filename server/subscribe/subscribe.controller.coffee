
'use strict'

_ = require 'lodash'
nodemailer = require 'nodemailer'
Subscribe = require './subscribe.model'

exports.index = (req, res) ->
  Subscribe.find (err, subscribes) ->
    return handleError(res, err)  if err
    res.status(200).json subscribes

exports.create = (req, res) ->
  Subscribe.create req.body, (err, subscribe) ->
  # console.log subscribe

    transporter = nodemailer.createTransport(
      service: 'Gmail'
      auth:
        user: 'clublootcom@gmail.com'
        pass: 'Arnon007')

    mailOptions =
      from: 'clublootcom@gmail.com'
      to: subscribe.email
      subject: 'Hello ✔'
      text: "thank you for subscribing to clubloot. We will notify you if you are this week's winner. Please stay tuned for exclusive information and an invitation to our private beta."
      html: "<b>thank you for subscribing to clubloot. We will notify you if you are this week's winner. Please stay tuned for exclusive information and an invitation to our private beta.</b>"

    transporter.sendMail mailOptions, (error, info) ->
      if error
        return console.log(error)
    # console.log 'Message sent: ' + info.response
      return

    return handleError(res, err)  if err
    res.status(201).json subscribe

handleError = (res, err) ->
  res.status(500).json err
