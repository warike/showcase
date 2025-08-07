import app from '@/app';
import { env } from '@/env';

const port = env.PORT;
app.listen(port, () => {
  console.log(`Server is up and running on port ${port}`);
});