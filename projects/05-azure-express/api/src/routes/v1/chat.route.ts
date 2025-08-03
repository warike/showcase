import { Router } from "express";
import * as ChatController from "@/controllers/chat.controller";

const router = Router();

router.post("/", ChatController.chat);

export default router;