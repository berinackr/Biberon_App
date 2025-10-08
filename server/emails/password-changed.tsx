import {
  Body,
  Button,
  Container,
  Head,
  Hr,
  Html,
  Link,
  Preview,
  Section,
  Text,
} from '@react-email/components';
import * as React from 'react';

interface SlackPasswordChangedProps {
  name: string;
  resetPasswordLink: string;
  date: string;
}

export const PasswordChanged = ({
  name,
  resetPasswordLink,
  date,
}: SlackPasswordChangedProps) => (
  <Html>
    <Head />
    <Preview>Biberon hesabını şifresini değiştirdiniz.</Preview>
    <Body style={main}>
      <Container style={container}>
        <Section style={logoContainer}>Logo</Section>
        <Text style={heroText}>
          Merhaba <strong style={nameText}>{name}</strong>, <br />
          <br />
          Hesabınızın şifresini <strong>{date}</strong> tarihinde değiştirdiniz.
          Eğer hesabınızın şifresini siz değiştirdiyseniz bu e-postayı dikkate
          almayınız.
        </Text>

        <Text style={heroText}>
          Ancak eğer hesabınızın şifresini siz değiştirmediyseniz, lütfen hemen
          aşağıdaki linke tıklayarak şifrenizi sıfırlayınız.
        </Text>

        <Button style={button} href={resetPasswordLink}>
          Şifreni Sıfırla
        </Button>

        <Text style={heroText}>
          Biberon hesabınızın güvenliği bizim için çok önemli. Bu nedenle
          şifrenizi sık sık değiştirmenizi ve güçlü şifreler kullanmanızı
          öneririz.
        </Text>

        <Hr />

        <Text
          style={{
            ...text,
            fontSize: '12px',
          }}
        >
          Eğer şifrenizi sıfırlama talebinde bulunmadıysanız, bu e-postayı
          dikkate almayınız. Hesabınızın güvende olması için lütfen bu e-postayı
          kimseyle paylaşmayınız.
        </Text>

        <Section>
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Websitemiz
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Politikalarımız
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
          >
            Yardım Merkezi
          </Link>
          &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
          <Link
            style={footerLink}
            href=""
            target="_blank"
            rel="noopener noreferrer"
            data-auth="NotApplicable"
            data-linkindex="6"
          >
            Hakkımızda
          </Link>
          <Text style={footerText}>
            Biberon App <br />
            Tüm hakları saklıdır.
          </Text>
        </Section>
      </Container>
    </Body>
  </Html>
);

PasswordChanged.PreviewProps = {
  name: 'John Doe',
  date: '01.01.2021, 12:00',
} as SlackPasswordChangedProps;

export default PasswordChanged;

const footerText = {
  fontSize: '12px',
  color: '#b7b7b7',
  lineHeight: '15px',
  textAlign: 'left' as const,
  marginBottom: '50px',
};

const nameText = {
  color: '#4a4a4a',
};

const footerLink = {
  color: '#b7b7b7',
  textDecoration: 'underline',
};

const button = {
  backgroundColor: '#1d1c1d',
  borderRadius: '4px',
  color: '#fff',
  fontFamily: "'Open Sans', 'Helvetica Neue', Arial",
  fontSize: '15px',
  textDecoration: 'none',
  textAlign: 'center' as const,
  display: 'block',
  width: '210px',
  padding: '14px 7px',
};

const main = {
  backgroundColor: '#ffffff',
  margin: '0 auto',
  fontFamily:
    "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif",
};

const container = {
  margin: '0 auto',
  padding: '0px 20px',
};

const logoContainer = {
  marginTop: '32px',
};

const heroText = {
  fontSize: '16px',
  lineHeight: '24px',
  marginBottom: '20px',
};

const text = {
  color: '#000',
  fontSize: '14px',
  lineHeight: '24px',
};
