import faker from '@faker-js/faker';
import Prisma from '@prisma/client';

const { PrismaClient } = Prisma;
const prisma = new PrismaClient();

async function seed() {
	// await prisma.user.create({
	// 	data: {
	// 		name: faker.name.findName(),
	// 		username: faker.name.lastName(),
	// 		uid: '2f5d3c63-37f9-4a59-86d2-476a0d530c27'
	// 	}
	// });

	for (let i = 0; i < 5; i++) {
		await prisma.project.create({
			data: {
				name: faker.animal.dog(),
				description: faker.lorem.sentence(),
				userId: 'b2b8a755-8bf9-45dc-81f2-045f7fd476e1'
			}
		});
	}
}

seed()
	.catch((e) => {
		console.error(e);
		process.exit(1);
	})
	.finally(async () => {
		await prisma.$disconnect();
	});
