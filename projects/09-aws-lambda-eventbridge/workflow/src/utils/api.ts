import { dataSchema, Data} from "../schema";
import { zocker } from "zocker";
import { faker } from "@faker-js/faker";

const data = [
  "es-ES", 
  "en-US"
].map(language => {
  return zocker(dataSchema)
    .supply(dataSchema.shape.email, "aws_sandbox_email@example.com")
    .supply(dataSchema.shape.language, language)
    .supply(dataSchema.shape.city_name, faker.location.city() )
    .generate();
})

export async function getData(): Promise<Data[]> {
  await new Promise(resolve => setTimeout(resolve, 3000));
  return data;
}