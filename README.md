# Delphi Gravatar Client

![Apache 2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

A lightweight and easy-to-use Delphi component for interacting with the Gravatar API. This client implements the official Gravatar API specifications (v3.0.0) with proper email hashing, profile retrieval, and avatar handling.

## Features

- ✅ SHA256 email hashing (following Gravatar specifications)
- ✅ Avatar URL generation
- ✅ Avatar image loading (JPG, PNG)
- ✅ Gravatar profile retrieval
- ✅ Proper error handling
- ✅ No external dependencies (uses Delphi's built-in components)
- ✅ Tested on Delphi 12.3 but should work from XE8 onwards

## Installation

Simply add `GravatarClient.pas` to your Delphi project. The unit has no external dependencies beyond the standard Delphi libraries.

## Getting Started

### Basic Usage

#### 1. Get Avatar URL

```pascal
uses
  GravatarClient;

var
  Gravatar: TGravatarClient;
  AvatarUrl: string;
begin
  Gravatar := TGravatarClient.Create;
  try
    // Get avatar URL for an email address, if you want to use image directly or in a web page
    AvatarUrl := Gravatar.GetAvatarUrl('example@example.com', 100, 'identicon');
    Writeln('Avatar URL: ' + AvatarUrl);
  finally
    Gravatar.Free;
  end;
end;
```

#### 2. Load Avatar Image

```pascal
uses
  GravatarClient, Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

var
  Gravatar: TGravatarClient;
  Avatar: TGraphic;
  ImageType: TGravatarImageType;   
begin
  Gravatar := TGravatarClient.Create;
  try
    // Load avatar into a TGraphic object
    Avatar := Gravatar.LoadAvatar('example@example.com', ImageType, 100, 'identicon');
    try
  	  //if you want to know file type, check "ImageType"
	  case ImageType of
	    gitPNG: lAvatar.SaveToFile('avatar.png');
	    gitJPG: lAvatar.SaveToFile('avatar.jpg');
	    else
		  lAvatar.SaveToFile('avatar.bmp');
	  end;
    finally
      Avatar.Free;
    end;
  finally
    Gravatar.Free;
  end;
end;
```

#### 3. Retrieve Profile Information

```pascal
uses
  GravatarClient, System.SysUtils;

var
  Gravatar: TGravatarClient;
  Profile: TGravatarProfile;
  Account: TGravatarAccount;
begin
  Gravatar := TGravatarClient.Create;
  try
    if Gravatar.GetProfile('example@example.com', Profile) then
    begin
      Writeln('Display Name: ' + Profile.DisplayName);
      Writeln('Profile URL: ' + Profile.ProfileUrl);
      Writeln('Thumbnail URL: ' + Profile.ThumbnailUrl);
      Writeln('About Me: ' + Profile.AboutMe);
      Writeln('Current Location: ' + Profile.CurrentLocation);
      
      Writeln(#13#10'Connected Accounts:');
      for Account in Profile.Accounts do
      begin
        Writeln(Format('- %s (%s): %s', [Account.Name, Account.Domain, Account.URL]));
      end;
    end
    else
    begin
      Writeln('Profile not found');
    end;
  finally
    Gravatar.Free;
  end;
end;
```

## API Usage Details

### Email Hashing

The client properly implements Gravatar's email hashing requirements:
1. Trims leading and trailing whitespace
2. Converts email to lowercase
3. Creates a SHA256 hash (NOT MD5)

This is handled internally by the `GetEmailHash` method, so you don't need to worry about the implementation details.

### Rate Limiting

- **Avatar endpoint requests do NOT count toward rate limits**
- Profile API requests are subject to rate limits (1000 requests per hour with API key)
- The client doesn't currently handle rate limit headers automatically, but you can check response headers in your application

### Error Handling

The client raises specific exceptions for errors:
- `EGravatar` exceptions for avatar loading failures
- Profile retrieval returns `False` when the profile isn't found

## Troubleshooting

### Common Issues

**Avatar not loading?**
- Verify the email is properly formatted (no extra spaces)
- Check if the user has actually set an avatar for that email
- Try using a default image parameter: `GetAvatarUrl(email, 80, 'identicon')`

**Profile not found?**
- Confirm you're using the primary email associated with the Gravatar account
- Note that avatar requests may succeed while profile requests fail for secondary emails

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Acknowledgements

This client follows the official Gravatar API specifications:
- API Version: 3.0.0
- Base URL: https://api.gravatar.com/v3
- OpenAPI Specification: https://api.gravatar.com/v3/openapi

## Related Projects

- [Gravatar Official Documentation](https://docs.gravatar.com/rest/api-data-specifications/)
- [Gravatar OpenAPI Specification](https://api.gravatar.com/v3/openapi)
