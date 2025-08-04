import { Router } from "express";
import * as ChatController from "@/controllers/chat.controller";

const router = Router();

router.post("/", ChatController.chat);
// router.post("/sse/", ChatController.chatSSE);

export default router;