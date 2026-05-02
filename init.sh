#!/bin/bash
if [ ! -f .env ]; then
	cp ./files/.env.example .env
  chmod 600 .env
fi
