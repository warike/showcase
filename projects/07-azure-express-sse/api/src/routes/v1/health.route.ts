import { Router } from "express";
import * as SystemController from "@/controllers/system.controller";

const router = Router();

router.get("/health", SystemController.healthCheck);

export default router;