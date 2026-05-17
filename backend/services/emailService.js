import nodemailer from 'nodemailer';

const sendVerificationEmail = async (email, code) => {
    console.log('\n==============================');
    console.log(`Verification code for: ${email}`);
    console.log(`Code: ${code}`);
    console.log('==============================\n');
};

export default sendVerificationEmail;